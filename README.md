# Analysis

## 1. Chosen organization

**MADM** is a digital music streaming platform built exclusively around artists based in Madrid. Its mission is to give visibility to local talent by creating a curated, closed ecosystem where every piece of content originates from the city. Beyond streaming, MADM connects listeners directly with artists through a built-in store where artists can sell merchandise, physical records, and concert tickets, turning passive listeners into active supporters of the Madrid music scene.

---

## 2. Problem or Need It Solves

Emerging artists in Madrid face a structural visibility problem on global streaming platforms, where algorithmic competition makes it nearly impossible to reach a relevant audience without an already established following.

MADM addresses this by removing that competition entirely. On this platform, the catalog is exclusively Madrid-based, which means every listener is already a potential fan, and every search or recommendation stays within the local scene. Artists do not compete against global acts for attention; they compete on the quality of their music alone.

At the same time, MADM recognises that music alone is not enough to sustain an independent artist. The integrated store allows artists to monetise their identity beyond streams, offering physical products and live experiences directly to their audience without relying on third-party services.

---

## **3. Information It Needs to Manage**

<aside>

### Users and Access

Listener accounts (free and premium), subscriptions, plans, and payments.

</aside>

<aside>

### Music catalog

Artists, albums, songs, genres, collaborations, and release dates.

</aside>

<aside>

### Administration

Validate artists.

</aside>

<aside>

### User Interaction

Play history, star ratings on songs, artist follows, playlist creation and following (premium only), album collections, and personalization preferences.

</aside>

<aside>

### Artist verification

Artist onboarding requests, review status, verification history, and review team management.

</aside>

<aside>

### Artist Store

Products offered by artists (merchandise, physical records, and concert tickets), product variants (sizes, formats, ticket categories), real-time inventory per variant, and order management.

</aside>

---

## 4. Main Processes

**1. Artist registration and verification**
An artist submits an onboarding request through the platform. An MADM administrator reviews the application and verifies Madrid residency. The request is then approved or rejected, with an assigned reviewer.

**2. Content publishing**
Once verified, the artist can upload songs and albums to the platform. All published content becomes immediately available in the catalog for every listener, regardless of their subscription plan.

**3. Music consumption**
Listeners browse and play songs from the catalog, give STARs to tracks, follow artists, and save albums to their personal collection. Every play is recorded individually, generating a full listening history per user.

**4. Subscription and payment management**
Users can upgrade to the premium plan at any time. The system manages the active subscription period, renewal dates, and associated payment records, allowing listeners to downgrade as needed.

**5. Playlist management**
Premium listeners can create their own playlists, add or remove songs, and make them available for other users to follow. Playlist ownership and follower relationships are tracked independently.

**6. Artist store and order management**
Artists can list products in their store, including merchandise, physical records, and concert tickets, each with defined variants and real inventory tracking. Listeners can place orders, which are recorded as individual order lines linked to specific product variants.

---

## **5. User Profiles**

<aside>

### **Free listener**

 Can browse the full catalog, play any song, follow artists, give STARs to tracks, and save albums to their personal collection. No subscription fee required.

</aside>

<aside>

### **Premium listener**

Includes everything available in the free tier, with the addition of playlist creation and management, the ability to follow other users' playlists, and access to personalization features. Requires an active paid subscription.

</aside>

<aside>

### Artist

Holds a separate account from any listener profile. Once verified by the MADM team, can upload songs and albums to the platform, manage their public profile and catalog, and operate their own store to sell merchandise, physical records, and concert tickets.

</aside>

<aside>

### **MADM Administrator**

Internal platform role responsible for reviewing artist onboarding requests, verifying Madrid residency. Manages the verification workflow and maintains the integrity of the platform's artist catalog.

</aside>

# E/R Diagram

![Diagrama diseñado con draw.io](docs/er_diagram.svg)

Diagrama diseñado con draw.io

# Relational model

![Diagrama diseñado con draw.io](docs/relational_model.svg)

Diagrama diseñado con draw.io

# Conclusion

This project is especially meaningful to me as an artist. I believe that creating a platform like MADM would be a very interesting and useful idea, and this database project has given me a first structured version of something I would like to keep developing throughout the year for my portfolio.

The project helped me understand more clearly how SQL can be used in real operations, not only in isolated exercises. For example, I learned how views can simplify repeated reports, how database users and profiles can separate responsibilities, and how triggers and procedures can enforce business rules directly in the database.

One of the most challenging parts was deciding the scope of the system. As I developed the idea, more and more possible features appeared: recommendations, events, ticketing, payments, artist dashboards, playlists, followers, rankings and many others. I had to decide which ones were essential and which ones should be left for future versions.

Another difficult area was database programming. Creating triggers to prevent actions such as free users creating playlists required careful thinking, because the database had to check the subscription status before allowing the operation. I also found errors when inserting sample data that did not fully match the business logic, so I had to review whether each insert made sense in context.

I also learned new modelling details, such as using a unique pair like (album_id, position) to avoid two songs having the same position inside the same album. This caused some errors at first, but it helped me understand better how constraints protect data integrity.

A design decision I consider important was creating Product_Variant as a separate table. This makes the store more realistic because each product can have different variants, such as sizes, editions or ticket categories, and each variant can have its own stock. It would have been possible to store this directly in Product, but separating it makes the model cleaner and easier to extend.

I also decided to create the Plan table instead of hardcoding subscription types. This makes the system more flexible, because new plans can be added in the future without changing the whole database structure.

Although MySQL works well for this academic version, a real streaming platform would probably require a more complex architecture. Some parts could eventually use other technologies, such as a document database for flexible recommendation data or a different storage system for large-scale listening events. However, this relational version is a strong starting point because it defines the main entities, relationships and business rules clearly.

In the future, I would improve the system by adding a graphical interface, more detailed payment records, better recommendation logic, audit logs for administrators, and additional master tables such as one for product types or genre classification. Overall, I think the project has been a good first step toward a more complete and realistic platform.