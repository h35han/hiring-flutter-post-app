# Flutter Posts App - Pull Request Template

## 🚀 Description

- Login against DummyJSON API with session persistence across app restarts
- Posts dashboard with featured (horizontal scroll) and recent (vertical list) sections
- Debounced search with server-side filtering
- `flutter_bloc` for state management, repository pattern for data access
- 40 unit tests covering models, repositories, cubits, and session handling

---

## 🏗️ Architecture & Solution Rationale

**Why BLoC over Provider:**
BLoC gives you a clear, testable contract. State is immutable, changes happen through methods, and the UI just rebuilds based on state. Provider is fine for simple apps, but once you have debounce timers, multiple loading states, and async error handling, BLoC keeps things organized. The `bloc_test` package also makes it easy to assert state transitions, which Provider doesn't offer.

**Why Cubit instead of full Bloc:**
For most of these features, full event classes are overkill. A `SearchPostsCubit` just needs an `onQueryChanged()` method. Writing a separate event class for that adds boilerplate with no real benefit. Cubit gives you the same testability with less noise. If the logic grew more complex, upgrading to full Bloc would be straightforward.

**Architecture Overview:**

- **Repository layer:** Each feature has its own repository (`AuthRepository`, `DashboardRepository`) that handles HTTP calls and token management. Repositories depend on a shared `SessionHandler` for token read/write and an `http.Client` for network calls. No abstract interfaces. In a one-day project, premature abstraction adds more cost than value.

- **Session layer:** `SessionHandler` sits in `core/` and owns a `broadcast StreamController`. When the token changes, it pushes a new `SessionState` to the stream. The router listens to this stream via `StreamListenable` to re-evaluate redirects, so login/logout instantly triggers navigation without extra wiring.

- **State management:** Each screen gets its own cubits. `DashboardScreen` creates three: `RecentPostsCubit`, `FeaturedPostsCubit`, `SearchPostsCubit`. They're scoped to the screen via `MultiBlocProvider` so they're disposed when you navigate away. `AuthCubit` lives at the app root because it persists across the whole session.

- **Widget layer:** Widgets use `BlocBuilder` for simple state rendering. The dashboard view uses Dart 3 `switch` expressions on sealed state classes for clean conditional rendering.

**Tradeoffs given the timebox:**
- Skipped abstract repository interfaces. Concrete classes are fine at this scale.
- No dependency injection framework. Manual `RepositoryProvider` wiring is straightforward enough.
- `http.Client` is a singleton created in `App`. Good enough, not factory-injected.
- Search pagination isn't fully wired. Search results don't infinite-scroll yet.

---

## 🔐 Authentication Implementation

**Token storage:** Used `flutter_secure_storage`. It encrypts tokens using the platform's keychain (iOS) and keystore (Android). `shared_preferences` stores data in plain text, which is fine for preferences but not for auth tokens.

**Session persistence:** On app start, `AuthCubit.sync()` checks if a token exists via `SessionHandler.getCachedToken()`. If one's found, it calls `/auth/me` to validate it and load the user profile. If the token is expired (401), it clears the session automatically. Users don't have to log in every time, but stale tokens don't stick around either.

**Error handling:**
- Invalid credentials: repository throws, cubit catches and emits `FailedAuthState`
- 401 from `/auth/me`: repository clears session and throws `UnauthorizedException`, cubit emits `UnauthenticatedAuthState`, router redirects to `/login`
- Network errors: same flow, cubit catches and shows a generic failure message

**Credentials used for testing:**
- Username: `emilys`, Password: `emilyspass`

---

## 💾 Data & State Management

**What's cached locally vs. fetched fresh:**
- Auth token: cached in secure storage, read on app start
- Posts: always fetched fresh, no local cache. DummyJSON is the source of truth.

**Pagination:** Each repository method takes an `offset` parameter. The UI passes the current list length as the offset to load the next page. The limit comes from `AppConfig.paginationLimit` (default 10, configurable via `--dart-define`).

**Search debounce:** `SearchPostsCubit` holds a `Timer?` that gets cancelled and restarted on every keystroke. After 400ms of inactivity, it fires the search. It also checks `if (query != state.query) return` after the API call, preventing stale results from overwriting newer ones. Empty queries immediately show the idle state.

---

## 🎨 Design Implementation

Built custom `HorizontalPostCard` and `VerticalPostCard` widgets in `lib/ui/organisms/post_cards.dart`. They follow a token-based design system. Colors come from `AppColors`, input styles from `appInputDecorationTheme`, checkbox styles from `appCheckboxThemeData`. Fonts use Google Fonts (Lexend Deca) via `appThemeData`.

**Loading/empty/error states:** Each cubit has an enum status (`initial`, `loading`, `success`, `failure`). The UI checks `state.errorMessage != null` and renders them in the theme's error color.

**Corners cut:** No skeleton loading states, no shimmer effects. The "Good Morning!" greeting is hardcoded. Avatar is a plain `CircleAvatar()` with no image.

---

## 🔌 API Integration & Networking

**HTTP setup:** Using the `http` package (not dio). A single `http.Client()` is created in `App` and injected into both repositories. No interceptors, no retry logic, no custom `BaseClient`.

**Error mapping:** HTTP errors are checked by status code in the repository. 401 throws a typed `UnauthorizedException`. Everything else bubbles up as a generic exception. The cubit catches everything and shows a user-friendly message.

**Request format:** POST for login (`/auth/login`), GET for everything else. Search hits `/posts/search?q=query`. Pagination uses `skip` and `limit` query params. Tokens go in `Authorization: Bearer <token>` header.

---

## ⚙️ Build Configuration

Using `--dart-define` for environment config. Three variables:

- `API_BASE_URL` : the API host
- `PAGINATION_LIMIT` : how many posts per page (default: 10)
- `SEARCH_DEBOUNCE_MS` : debounce delay (default: 300)

Read in `AppConfig` via `String.fromEnvironment` / `int.fromEnvironment`. No flavors or separate entry points. Simplest approach that works cross-platform.

---

## 🧪 Unit Testing Coverage

40 tests, all passing. Focused on business logic only, no widget tests.

**What's tested:**
- Models: `User.fromJson` (valid + missing field), `Post.fromJson` + `toJson` roundtrip
- Session handler: initial state, set/clear session, token caching
- Auth repository: login success, 401 handling, getUser, request body verification
- Dashboard repository: fetch recent/featured/search posts, empty responses, malformed JSON
- Auth cubit: initial state, login success/failure, logout, session sync
- Recent/Featured posts cubits: initial state, load success/failure, refresh
- Search posts cubit: initial state, empty query, debounce, timer cancellation, error handling, clear

**What's not tested:**
- Widget rendering. Mandate was business logic only.
- `AppConfig`. Just reads env vars, nothing to test.
- Router redirects. Integration test territory.
- `StreamListenable`. Plumbing code, tested implicitly through app behavior.

**Mocking approach:** Hand-written fakes and stubs, no code generation. `FakeSecureStorage` with an in-memory map, `StubHttpClient` wrapping `MockClient` with pattern-based stubbing, `FakeAuthRepository` and `FakeDashboardRepository` with configurable behavior. Fast, readable, no generated code to maintain.

**Testing checklist:**
- [x] Auth logic (login success/failure, token persistence, logout, session restore)
- [x] Repository layer (API calls, model mapping, error mapping)
- [x] BLoC/Cubit (state transitions, search debounce, pagination)
- [x] Data model (de)serialization

---

## 📌 Known Limitations / Assumptions

- Search results don't have infinite scroll. Only shows first page.
- No pull-to-refresh on search results (only on main dashboard)
- "Remember me" checkbox is wired in the UI but doesn't do anything
- Post detail screen isn't implemented. Tapping a post doesn't navigate anywhere.
- No token refresh mechanism. Expires after 60 minutes, user re-logs in.
- Error messages are generic ("Authentication failed"). No server error detail forwarding.
- Three env configs via `--dart-define` but no dev/staging/prod separation in code

---

## 🛠️ Setup Instructions

**Prerequisites:**
- Flutter 3.19+ / Dart 3+

**Run:**
```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=https://dummyjson.com --dart-define=PAGINATION_LIMIT=10 --dart-define=SEARCH_DEBOUNCE_MS=300
```

**Test:**
```bash
flutter test --coverage
```

---

## ✅ Feature Completion Checklist

### 🔐 Authentication
- [x] Login screen against DummyJSON
- [x] Token storage and persistent session
- [x] Logout
- [x] Validation and error handling

### 📱 Dashboard & Posts
- [x] Posts list matching Figma design
- [x] Backend search with debounce
- [x] Pagination (offset-based, not infinite scroll)
- [x] Pull-to-refresh
- [ ] Post detail screen
- [x] Loading/empty/error states

### 🏗️ Architecture & Data
- [x] Repository pattern implemented
- [x] BLoC used consistently
- [x] Async/await networking
- [x] Proper separation of concerns

### ⚙️ Configuration & Testing
- [x] Environment config via `--dart-define`
- [x] Unit tests with 40 tests on business logic
- [x] Edge cases and error scenarios tested

### 📋 Documentation & Quality
- [x] Clean, readable code
- [x] README with setup instructions
- [x] Demo video included (media/simulator.mov)
