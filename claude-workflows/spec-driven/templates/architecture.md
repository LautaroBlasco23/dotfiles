# Architecture

## Layers

| Layer          | Path               | Responsibility                             |
|----------------|--------------------|--------------------------------------------|
| Core           | `core/`            | Domain entities, repository interfaces     |
| Application    | `application/`     | Use cases, services, business logic        |
| Infrastructure | `infrastructure/`  | DB implementations, external integrations |
| API            | `api/`             | HTTP handlers, request/response mapping    |

## Import Rules

- `core/` must NOT import `application/`, `infrastructure/`, or `api/`
- `application/` must NOT import `infrastructure/` or `api/`
- `infrastructure/` must NOT import `api/`
- Circular imports between any two packages are forbidden

## Repository Pattern

- Repository interfaces are defined in `core/`
- Repository implementations live in `infrastructure/`
- Application services depend on the interface, never the implementation

## File Placement

| What                        | Where                          |
|-----------------------------|--------------------------------|
| Domain entities             | `core/`                        |
| Repository interfaces       | `core/`                        |
| Service / use case          | `application/`                 |
| DB repository               | `infrastructure/`              |
| HTTP handler                | `api/`                         |
| Request / response types    | `api/`                         |

## Naming Conventions

- Entities: `Order`, `User` (PascalCase)
- Repository interfaces: `OrderRepository`, `UserRepository`
- Services: `OrderService`, `UserService`
- Handlers: `OrderHandler`, `UserHandler`
- DB implementations: `PostgresOrderRepository`
