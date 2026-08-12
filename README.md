## Student Information

**Name:** Justine Francis Sta. Ana  

**Course:** CTADMOBL – Advance Mobile Programming  

**Lab Activity:** Lab Activity 1 & 2

---

## Lab Activity 1: Discussion

Sa lab activity na ito, natutunan ko kung paano gamitin ang iba't ibang uri ng state management sa Flutter. Gumamit ako ng **setState()** para sa counter functionality dahil ito ay isang halimbawa ng Ephemeral State kung saan ang pagbabago ng value ay nakakaapekto lamang sa isang widget o screen.

Bukod dito, gumamit din ako ng **Provider** para sa Dark Mode at Light Mode feature. Ito naman ay isang halimbawa ng App State dahil ang pagbabago ng theme ay naaapektuhan ang buong application at maaaring magamit sa iba't ibang bahagi ng app.

Sa paggawa ng activity na ito, mas naunawaan ko kung paano mag-manage ng state sa Flutter at kung kailan dapat gamitin ang setState() at Provider. Natutunan ko rin kung paano gumawa ng mas organisado at mas madaling i-maintain na mobile application gamit ang tamang state management techniques.


## Lab Activity 2: Discussion

**How the model, services, and screen interact to render the API endpoint:**

The `Product` model describes what a product looks like, such as its title, price, description, and images. It also uses `fromJson()` to convert the API's JSON response into a `Product` object.

The `ProductService` is responsible for communicating with the API. It sends a request to `$host/products`, receives the JSON response, and converts the data into a list of `Product` objects.

The `HomeScreen` uses the service to retrieve and display the products. It shows a loading indicator while waiting for the API, an error message if the request fails, and the product list when the data is successfully loaded. When a product is selected, it opens the `ProductScreen` and passes the selected product to it.

Basically, the model handles the data, the service handles the API request, and the screen handles displaying the information. Separating these responsibilities makes the code easier to understand, maintain, and troubleshoot.

**New design pattern used in this activity:**

This activity uses the **Service Pattern**, where API and networking operations are placed inside the `ProductService` instead of directly inside the screen. This keeps the UI code cleaner and separates the application's display logic from its networking logic.

It also manages different API states such as loading, error, and success using `async/await` and `setState`, which allows the screen to respond to each stage of the request without mixing networking logic into the UI.
