---
id: T1
title: Add user authentication to the login flow
depends_on: []
status: pending
---

## Context

The application currently has no authentication. Users navigate directly to the
dashboard. This task adds a login page and session management to restrict access.

## Inputs

- `src/routes.py` — current route definitions
- `src/models/user.py` — User model (has `username` and `password_hash` fields)
- `docs/auth-spec.md` — product requirements for the login flow

## Outputs

- `src/routes/auth.py` — login and logout route handlers
- `src/templates/login.html` — the login form
- `tests/test_auth.py` — tests for login success, wrong password, session expiry

## Acceptance Criteria

- [ ] `GET /login` renders the login form
- [ ] `POST /login` with correct credentials sets a session cookie, redirects to `/dashboard`
- [ ] `POST /login` with wrong credentials renders form with an error message
- [ ] `GET /logout` clears the session and redirects to `/login`
- [ ] `GET /dashboard` without a session redirects to `/login`
- [ ] All tests pass: `pytest tests/test_auth.py -v`
- [ ] `python cairn/tools/validate.py` passes (exit 0)

## Notes

`password_hash` uses bcrypt from the existing `requirements.txt` — do not add a new
dependency. Session secret is in `config.py` as `SESSION_SECRET`.
