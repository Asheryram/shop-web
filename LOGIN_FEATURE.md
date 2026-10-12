# Shop login experience

## Goal

Let a customer create an account and sign in to the shop website.

## Frontend feature

Add a dedicated customer-facing account page at `/login` to `shop-web`, reachable from the shop header, with sign-in and registration modes.

## Expected behavior

- Provide a login page or clearly reachable login form that fits the existing shop UI.
- Collect the account identifier and password and submit them to the authentication API provided by `shop-api`.
- Let a new customer create an account with an email address and a password of at least 12 characters, including password confirmation.
- Show an in-progress state while sign-in is being checked.
- On successful authentication, show that the customer is signed in and make the authenticated state available to the shop UI.
- On invalid credentials, show a helpful message without claiming the customer is signed in.
- On network or server errors, show a recoverable error and allow the customer to try again.
- Keep credentials out of URLs, browser logs, and user-facing error messages.
- Restore the signed-in state after reload using the authentication mechanism agreed with the backend team.

## Acceptance criteria

- A customer can reach the login form from the shop website and submit credentials.
- A customer can switch to registration, create an account, and is signed in after successful registration.
- A successful backend response updates the UI to a signed-in state.
- Invalid credentials and service errors leave the customer signed out and provide clear feedback.
- The frontend follows the API contract and browser-authentication behavior documented by the backend team; it does not assume a token or session format.

## Coordination

The backend owns its feature definition and authentication implementation. Agree on the request/response contract and browser authentication behavior before integrating.

## Implemented API contract

The website uses `POST /api/auth/login` and `POST /api/auth/register` with JSON `{ "email": "...", "password": "..." }` and sends browser credentials with `credentials: "include"`. Registration requires a password of at least 12 characters and returns HTTP 409 when the email is already registered. Successful login or registration identifies the customer as `{ "authenticated": true, "customer": { "id": 1, "email": "..." } }`. Invalid credentials return HTTP 401 with a generic message. The API maintains an HttpOnly, Secure, SameSite=None session cookie, so the website does not read, store, or assume a token format.

On page load the website calls `GET /api/auth/session` to restore the state. It signs out through `POST /api/auth/logout`. The API must have `WEB_ORIGIN` configured to this site's exact HTTPS origin and both services must use HTTPS for cookie authentication.

The shop header links to the standalone `/login` page. The SPA server's existing fallback serves the app shell for that route; the page then displays the login experience separately from the product dashboard.
