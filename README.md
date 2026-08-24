# Lab Activity 4 – Persistent Authentication, User Profile, and Cart Using Provider

## Student Information

Name: Justine Francis Sta. Ana

Course: CTADMOBL – Advance Mobile Programming

Lab Activity: Lab Activity 4

## Lab Activity 4: Discussion

1. How the User model works.
The `User` model is a structured representation of the logged-in account returned by the API. It stores the user ID, username, email, names, gender, image, access token, refresh token, and token values when available. The `User.fromJson()` factory safely reads the API response and converts it to a Dart object, while `toJson()` can be used when the data needs to be sent back in a consistent structure. Missing values are handled with safe defaults so the app does not crash when optional fields are absent.

2. How UserService communicates with the API.
The `UserService` uses the configured host from `constants.dart` and sends a POST request to `$host/auth/login` with the username, password, and expiry value. If the request succeeds, it decodes the API response, maps it to a `User`, and saves the result to `SharedPreferences`. If the API request fails, the service throws an exception that is displayed by the sign-in screen as a login error message.

3. How the Sign In Screen communicates with UserService.
The `SignInScreen` collects the username and password from the text fields, validates the form, and then calls `UserService.loginUser(username, password)`. When the response comes back, it sets the loading state to false and navigates to the home screen with the returned user payload. This keeps the login flow simple while reusing the service layer for authentication logic.

4. How SharedPreferences stores the authenticated user's information.
The `saveUserData()` method in `UserService` gets an instance of `SharedPreferences` and stores the user data under keys such as `id`, `username`, `email`, `firstName`, `lastName`, `gender`, `image`, `accessToken`, `refreshToken`, and `token`. These keys allow the app to restore the same session even after the app is closed and reopened.

5. How persistent authentication works on the Splash Screen.
The `SplashScreen` shows a custom loading layout for about 1.5 seconds and then calls `UserService.isLoggedIn()`. If a valid token is still present in `SharedPreferences`, the app loads the saved user data and redirects to `/home`. If no valid token is found, the app redirects to `/signin`. This is persistent authentication because the session remains saved locally across app restarts.

6. How the Profile Screen retrieves and displays the logged-in user's data.
The `ProfileScreen` calls `UserService.getUserData()` to get the saved data from local storage, then converts it into a `User` model. It displays the full name, username, email, gender, and user ID using the actual saved values. The profile image is loaded when available; otherwise, a placeholder icon is shown instead of causing an error.

7. How the saved userId is used to retrieve/render the user's cart.
The saved user ID is pulled from the authenticated user data using `UserService` and `SharedPreferences`. The profile screen and cart logic then use that user ID when calling the cart API through `CartService.getCartsByUser(userId)`. This ensures that only the cart belonging to the currently logged-in user is displayed instead of a hardcoded cart.

8. How models, services, screens, and providers are separated in the updated design pattern.
The updated design pattern keeps the app organized into clear responsibilities. The `User` model defines the data shape, `UserService` handles API communication and persistence, the screens manage UI and navigation, and the provider layer continues to manage cart state and settings. This separation makes the app easier to maintain and improves readability, especially for authentication and persistence features.

9. What was implemented for Enhancement 1.
Enhancement 1 created a custom splash screen with the NUBD Exchange logo, a centered title, and a loading spinner. The screen waits briefly and then checks persistent authentication using `UserService.isLoggedIn()`. It redirects to `/home` for authenticated users and `/signin` for unauthenticated users.

10. What was implemented for Enhancement 2.
Enhancement 2 created a custom sign-in screen with a clean layout matching the provided sample: logo, welcome text, username field, password field, and a login button. It validates credentials, handles loading, calls the login API, and navigates to the home screen after successful authentication.

11. What was implemented for Enhancement 3.
Enhancement 3 created the `User` model and connected it to the project’s login and profile flow. The profile screen now reads the saved user information, shows real user details, supports logout, and loads the cart associated with the saved user ID.

## Git instructions

1. `git checkout -b lab_act4`
2. `git add .`
3. `git commit -m "lab_act4"`
4. `git push origin lab_act4`

