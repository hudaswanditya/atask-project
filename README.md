# Wallet, User, Team, and Stock Management System

This project is a Ruby on Rails API application designed to manage entities such as Users, Teams, and Stocks, with a financial transaction system using wallets for storing and transferring balances. Users can buy and sell stocks, and the system ensures precision and consistency for all financial operations.

## Key Features
- **API-Only Application:** This app is built as an API-only Rails application, meaning it is optimized for handling API requests and does not include views, helpers, or assets.
- **PostgreSQL Database:** The app uses PostgreSQL as the database management system to ensure strong data consistency, supporting the ACID (Atomicity, Consistency, Isolation, Durability) principles for all transactions.
- **Wallets for Financial Management:** Users can manage their funds using wallets, which allow for deposits, withdrawals, and transfers. Each user has a wallet that can interact with different stocks.
- **Stock Management:** Users can buy, sell, and track stocks, with transactions handled through their wallets, maintaining balance accuracy and precise stock management.

---

## Features

1. **User and Team Management**
   - Users belong to teams, ensuring clear associations between members and their groups.
   - Teams can collectively manage assets and financial operations.

2. **Wallet System**
   - Every `User` and `Team` has a unique **Wallet**.
   - Wallets support **credits** (adding funds) and **debits** (deducting funds).
   - Balances are calculated dynamically by summing associated transactions.

3. **Stock Management**
   - Stocks have attributes such as `symbol`, `name`, `last_price`, `day_high`, `day_low`, and more.
   - Users can **buy** and **sell stocks**, with shares tracked for each user.
   - Stock prices are updated dynamically using the **LatestStockPrice** library, which integrates with the RapidAPI stock price API.

4. **Transaction Log**
   - Every financial operation (credit or debit) is recorded in a **TransactionLog**, ensuring an audit trail for all wallet activities.
   - Validations ensure the integrity of transactions (e.g., source wallet for credits is `nil`, target wallet for debits is `nil`).

5. **Precision and Consistency**
   - Financial operations use `BigDecimal` to ensure accuracy in calculations.
   - Wallet operations follow the **ACID** principles, ensuring transactional integrity.

---

## Endpoints

### **Authentication**

#### **Sign In**
- **Endpoint:** `POST /users/sign_in`  
- **Description:** Allows a user to sign in.  

#### **Sign Out**
- **Endpoint:** `DELETE /users/sign_out`  
- **Description:** Allows a user to sign out.  

---

### **User**
These routes are scoped for individual users (`/users/:id`) and include both standard and custom actions.

#### **Get User Details**
- **Endpoint:** `GET /users/:id`  
- **Description:** Retrieve details of a specific user.  

#### **Update User**
- **Endpoint:** `PATCH /users/:id`  
- **Description:** Update a user's details.  

#### **Delete User**
- **Endpoint:** `DELETE /users/:id`  
- **Description:** Delete a specific user.  

---

### **Wallet Management**

#### **View Wallet Balance**
- **Endpoint:** `GET /users/:id/wallet`  
- **Description:** Retrieve the wallet balance of a specific user.  

#### **Credit Wallet**
- **Endpoint:** `POST /users/:id/credit_wallet`  
- **Description:** Add funds to a user's wallet.  

#### **Debit Wallet**
- **Endpoint:** `POST /users/:id/debit_wallet`  
- **Description:** Withdraw funds from a user's wallet.  

#### **Transfer Money Between Wallets**
- **Endpoint:** `POST /users/:id/transfer`  
- **Description:** Transfer money between wallets.  

---

### **Stock Management**

#### **View Stock Shares**
- **Endpoint:** `GET /users/:id/stock_shares`  
- **Description:** Retrieve the stock shares owned by a user.  

#### **View All Stocks**
- **Endpoint:** `GET /users/:id/stocks`  
- **Description:** Retrieve a list of all available stocks.  

#### **Buy Stock**
- **Endpoint:** `POST /users/:id/buy_stock`  
- **Description:** Buy shares of a stock.  

#### **Sell Stock**
- **Endpoint:** `POST /users/:id/sell_stock`  
- **Description:** Sell shares of a stock.  


### Summary Table
| **HTTP Method** | **Endpoint**               | **Action**                  | **Description**                       |
|------------------|----------------------------|-----------------------------|---------------------------------------|
| POST             | `/users/sign_in`          | `users#sign_in`             | Sign in a user                        |
| DELETE           | `/users/sign_out`         | `users#sign_out`            | Sign out a user                       |
| GET              | `/users/:id`              | `users#show`                | Get user details                      |
| PATCH            | `/users/:id`              | `users#update`              | Update user details                   |
| DELETE           | `/users/:id`              | `users#destroy`             | Delete a user                         |
| GET              | `/users/:id/wallet`       | `users#wallet`              | View wallet balance                   |
| POST             | `/users/:id/credit_wallet` | `users#credit_wallet`      | Credit wallet                         |
| POST             | `/users/:id/debit_wallet` | `users#debit_wallet`        | Debit wallet                          |
| POST             | `/users/:id/transfer`     | `users#transfer`            | Transfer money between wallets        |
| GET              | `/users/:id/stock_shares` | `users#stock_shares`        | View user's stock shares              |
| GET              | `/users/:id/stocks`       | `users#stocks`              | View all available stocks             |
| POST             | `/users/:id/buy_stock`    | `users#buy_stock`           | Buy stock shares                      |
| POST             | `/users/:id/sell_stock`   | `users#sell_stock`          | Sell stock shares                     |


---

## Setup Instructions

1. **Clone the Repository**
    ```
    git clone <repository-url>
    cd <repository-folder>
    ```
  
2. **Install Dependencies**
    ```
	bundle install
	```
3. **Setup the Database**
	```
	rails db:setup
	```
4. **Run the Server**
	```
	rails server
	```