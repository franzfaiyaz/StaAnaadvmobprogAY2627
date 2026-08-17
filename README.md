## Lab Activity 3: Discussion

**How the cart model, services, and screen interact to render the API endpoint going to the same detail_screen.dart:**

The `Cart` and `CartProduct` models define the structure of the shopping cart data. The `Cart` model contains a list of `CartProduct` items, along with totals, discounts, and user information. Both models include `fromJson()` factory constructors to parse the API's JSON response into Dart objects, and `toJson()` methods to convert them back for sending data to the API.

The `CartService` handles all cart-related API operations. It fetches all carts using `getAllCarts()`, retrieves a specific user's cart with `getCartByUserId(userId)`, and adds products to the cart using `addToCart()`. This service communicates with the dummyjson API endpoints (`/carts`, `/carts/user/{userId}`, and `/carts/add`), making it the single point of responsibility for all cart operations.

The `CartScreen` displays the cart items fetched by `CartService`. When a cart is loaded, each `CartProduct` in the cart becomes clickable. Tapping on a cart item navigates the user to the `ProductScreen` (detail_screen) for that product, allowing them to view detailed information. This creates a seamless flow where users can browse products, add them to the cart, review their cart, and dive into product details directly from the cart.

**Design Pattern and Enhancement Details:**

**Enhancement 1 - Cart Screen with Clickable Items:** The `CartScreen` renders all cart items in a scrollable list. Each item displays the product image, title, price, quantity, discount information, and quantity adjustment buttons (+ and −). Items are wrapped in `GestureDetector` to make them tappable, navigating to `ProductScreen` by passing the `productId`.

**Enhancement 2 - FloatingActionButton Navigation:** The bottom navigation has been converted to a `FloatingActionButton` on the `HomeScreen`. The `FloatingActionButton` (with a shopping cart icon) navigates to the `CartScreen`. When the user is on the `CartScreen`, the `FloatingActionButton` is hidden (`floatingActionButton: null`), keeping the UI clean and preventing accidental navigation away from the cart. The cart screen uses a traditional `BottomNavigationBar` for navigation instead.

**Enhancement 3 - Cart API Integration:** The implementation uses the dummyjson Cart API to integrate cart functionality. The `getCartByUserId()` method fetches a specific user's cart by ID (e.g., user 1), rendering only that user's cart. The `addToCart()` method sends a POST request to `/carts/add` with the product ID and quantity, allowing users to add products to their cart programmatically.

**Using getById at Cart Endpoint:** The dummyjson Cart API supports `getById()` functionality through the `/carts/{id}` endpoint, which retrieves a specific cart by its ID. Additionally, `/carts/user/{userId}` retrieves all carts associated with a specific user. This allows the app to display user-specific carts and maintain separate cart instances for different users.

**Summary:**
The updated design pattern in Lab Activity 3 maintains the **Service Pattern** while extending it to handle complex cart operations. The `CartScreen` demonstrates how to make API-fetched data interactive by adding navigation to detail screens. The transition from a bottom navigation bar to a `FloatingActionButton` improves UX by providing quick access to the cart from the product browsing screen, while the hidden FAB on the cart screen maintains focus on completing the purchase flow.

