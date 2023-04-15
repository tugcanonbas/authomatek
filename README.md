# Authomatek

Authomatek is a Swift package for Vapor that provides pre-configured authentication for relational databases. It automates the process of creating all the necessary routes, controllers, and models, allowing you to quickly and easily set up authentication for your Vapor application.

With Authomatek, you can get up and running with secure user authentication in no time. Additionally, Authomatek supports JSON Web Tokens (JWT) for secure user authentication and authorization.

## Features

---

- User registration
- User login (with JWT)
- User logout
- User JWT refresh

## Routes

---

| URL            | HTTP Method | Description                    | Content (Body)      |
| -------------- | :---------: | ------------------------------ | ------------------- |
| /auth/register |    POST     | Registers a new user           | `User.DTO.Register` |
| /auth/login    |    POST     | Login with existing user       | `User.DTO.Login`    |
| /auth/logout   |     GET     | Logout with existing user      | Bearer Token        |
| /auth/refresh  |     GET     | Refresh the existing JWT token | Bearer Token        |

## Installation

---

Authomatek can be installed using Swift Package Manager. Simply add the following line to your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/tugcanonbas/authomatek.git", from: "0.0.1")
]
```

```swift
dependencies: [
    .product(name: "Authomatek", package: "authomatek"),
],
```

### Environment variables

---

| Key                                | Default Value | Description              |
| ---------------------------------- | ------------- | ------------------------ |
| `SECRET_KEY_FILE_PATH`             | none          | .pem file path for JWT   |
| `ACCESS_EXPIRATION_DATE_INTERVAL`  | `3600`        | Access Token expiration  |
| `REFRESH_EXPIRATION_DATE_INTERVAL` | `604800`      | Refresh Token expiration |

### Configuration

---

- First you need to generate a private key for JWT. You can use the following command to generate a private key.

```bash
ssh-keygen -t rsa -b 4096 -m PEM -f {{name_of_file}}.key
```

- Then you need to add the following environment variables to your .env file.

```
SECRET_KEY_FILE_PATH="{{.pem file path}}"
```

- Finally, all you need to do is to add the following line to your configure.swift file before migrations.

```swift
import Authomatek
...
...
try Authomatek.configure(app)
```

Authomatek will automatically create the necessary routes, controllers, models and migrations for you.

### Customization

---

- Route and controller customization

```swift
struct AuthoConnectable: AuthoControllable {
// Custom controller code
}
```

```swift
let config = RouteConfig(path: "api", "v1", "authomatek", register: "register", login: "login", logout: "logout", refresh: "refresh")
let controller = AuthoConnectable()
try Authomatek.configure(app, configuration: config, controller: controller)
```

### Models

---

#### User Protocol

```swift
protocol User {
    var id: UUID? { get }
    var email: String { get }
    var username: String { get }
    var passwordHash: String { get }
    var status: UserStatus { get }
    var createdAt: Date? { get }
    var updatedAt: Date? { get }
    var deletedAt: Date? { get }
}
```

#### UserStatus Enum

```swift
enum UserStatus: String, Codable {
    case active
    case inactive
    case deleted
}
```

#### User DTOs

```swift
public extension UserModel {
    enum DTO {
        public struct User: Content {
            let id: UUID
            let email: String
            let username: String
            let status: UserStatus
            let createdAt: Date
            let updatedAt: Date
            let deletedAt: Date?
        }

        public struct Users: Content {
            let count: Int
            let users: [User]

            ...
        }

        public struct Register: Content, Validatable {
            let email: String
            let username: String
            let password: String

            ...
        }

        public struct Login: Content, Validatable {
            let email: String?
            let username: String?
            let password: String

            ...
        }
    }
}
```

#### Validations

```swift
let usernameValidators: Validator<String> = .count(3...) && .alphanumeric && .pattern(#"^[a-zA-Z0-9-_.]*$"#)

validations.add(ValidationKeys.email, as: String.self, is: .email, required: false)
validations.add(ValidationKeys.username, as: String.self, is: usernameValidators, required: false)
validations.add(ValidationKeys.password, as: String.self, is: .count(8...), required: true)
```

## License

ConnectableKit is available under the MIT license. See the LICENSE file for more info.
