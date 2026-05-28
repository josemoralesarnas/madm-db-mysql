# MADM

Creado: 26 de mayo de 2026 10:32

![First logo idea designed by me](docs/logo.png)

First logo idea designed by me

# MADM

> Your music platform for Madrid-based artists.
> 

The objective of this project was to design and implement a complete information system based on a realistic business case. The work required analysing the needs of an organisation, creating a conceptual and relational database model, implementing it in MySQL, inserting sample data, writing business-oriented queries, and adding database administration and programming elements such as views, indexes, users, procedures, triggers, and events.

I chose MADM because it is a project connected to my interests as an artist and because it represents a realistic platform with many information needs: users, artists, music catalogues, subscriptions, playlists, verification processes, orders, products, and inventory. This made it a strong case for practising database design in a real context instead of building a simple or disconnected set of tables.

---

# Analysis

## 1. Chosen organization

MADM is a digital music streaming platform built around artists based in Madrid. Its mission is to give visibility to local talent by creating a curated ecosystem focused on the city’s music scene. Beyond streaming, MADM connects listeners directly with artists through a built-in store where artists can sell merchandise, physical records, and concert tickets, turning passive listeners into active supporters of Madrid’s local music community.

---

## 2. Problem or Need It Solves

Emerging artists in Madrid face a visibility problem on global streaming platforms, where algorithmic competition makes it difficult to reach a relevant audience without an already established following.

MADM addresses this by creating a local-first platform focused exclusively on Madrid-based artists. This reduces competition with global acts and makes music discovery more relevant for listeners who are already interested in the local scene. Searches, browsing, playlists, and catalog exploration remain within the Madrid music ecosystem.

At the same time, MADM recognises that music streaming alone is not always enough to sustain an independent artist. The integrated store allows artists to monetise their identity beyond streams, offering merchandise, physical records, and concert tickets directly to their audience.

---

## **3. Information It Needs to Manage**

<aside>

### Users and Access

Listener accounts, free and paid plans, active subscriptions, subscription periods, and payment methods.

</aside>

<aside>

### Music catalog

Artists, albums, songs, genres, collaborations, release dates, and song-album positioning.

</aside>

<aside>

### Administration

Administrator profiles, artist onboarding requests, review status, assigned reviewers, and artist verification.

</aside>

<aside>

### User Interaction

Play history, song stars, artist follows, playlist creation for premium users, playlist following, and album collections.

</aside>

<aside>

### Artist Store

Products offered by artists, product variants, stock per variant, customer orders, and order lines.

</aside>

---

## 4. Main Processes

**1. Artist registration and verification**
An artist submits an onboarding request through the platform. A MADM administrator reviews the application and verifies Madrid residency. The request is then approved or rejected, with an assigned reviewer and review date.

**2. Content publishing**
Once verified, the artist can publish songs and albums on the platform. Published content becomes available in the catalog for every listener, regardless of their subscription plan.

**3. Music consumption**
Listeners browse and play songs from the catalog, star tracks, follow artists, and save albums to their personal collection. Every play is recorded individually, generating a listening history per user.

**4. Subscription and payment management**
Users can have free, premium, or family plans. The system manages the active subscription period, plan type, status, and payment method.

**5. Playlist management**
Premium listeners can create and manage their own playlists. Songs are added to playlists with a defined position, and other users can follow public playlists. Playlist ownership and follower relationships are tracked independently.

**6. Artist store and order management**
Artists can list products in their store, including merchandise, physical records, and concert tickets. Each product can have variants, such as sizes, editions, or ticket categories, with stock tracked per variant. Listeners can place orders, which are recorded as order lines linked to specific product variants.

---

## **5. Functional User Profiles**

<aside>

### **Free listener**

 Can browse the full catalog, play any song, follow artists, give STARs to tracks, and save albums to their personal collection. No subscription fee required.

</aside>

<aside>

### **Premium listener**

Includes everything available in the free tier, with the addition of playlist creation and management. Premium access requires an active paid subscription.

</aside>

<aside>

### Artist

An artist is an account role within the platform. Once verified by the MADM team, the artist can manage their public profile, publish songs and albums, and operate their own store to sell merchandise, physical records, and concert tickets.

</aside>

<aside>

### **MADM Administrator**

Internal platform role responsible for reviewing artist onboarding requests, verifying Madrid residency. Manages the verification workflow and maintains the integrity of the platform's artist catalog.

</aside>

The platform has functional user profiles such as free listener, premium listener, artist and MADM administrator. In addition, the database defines technical access profiles to control how different services or internal operators can access the data. These database users are not listener accounts; they are MySQL users created to separate responsibilities and apply the principle of least privilege.

---

## 6. Technical Access Profiles

<aside>

### **Database administrator**

Technical MySQL profile with full privileges over the madm database. This profile is intended for trusted technical staff responsible for maintaining the database structure, managing permissions, and solving critical issues. It should be used carefully because it can read, insert, update, delete, and modify any database object.

</aside>

<aside>

### **Read-only profile**

Technical MySQL profile designed for reporting, auditing, or data analysis. It can only read information from the database through SELECT queries and cannot modify any data. This makes it useful for dashboards or external review without risking accidental changes.

</aside>

<aside>

### **Store operator**

Technical MySQL profile focused on order and inventory management. It can read, insert, and update orders and order lines, and can read or update inventory stock. It cannot modify sensitive areas such as user accounts, subscriptions, artist verification, administrators, or the music catalog.

</aside>

---

# E/R Diagram

![Diagrama diseñado con draw.io](docs/er_diagram.svg)

Diagrama diseñado con draw.io

---

# Relational model

![Diagrama diseñado con draw.io](docs/relational_model.svg)

Diagrama diseñado con draw.io

---

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