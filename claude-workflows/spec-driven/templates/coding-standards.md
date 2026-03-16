# Coding Standards

## Language
Go

## Package Naming
- Lowercase, single word: `order`, `user`, `product`
- No underscores or mixed case in package names

## Error Handling
- Return errors as the last return value
- Wrap errors with context: `fmt.Errorf("order service: create: %w", err)`
- Define domain errors in `core/`: `ErrOrderNotFound`, `ErrInsufficientStock`
- Do not log errors at the service layer — let the handler decide

## Validation
- Validate at the API boundary (handler or request type)
- Do not validate the same rule twice in different layers
- Use typed errors for domain validation failures

## Testing
- Unit tests live next to the file they test: `order_service_test.go`
- Integration tests live in `infrastructure/` with a `_integration_test.go` suffix
- Use table-driven tests
- Test behavior, not implementation

## Context
- All service and repository methods accept `context.Context` as the first parameter
- Do not store context in structs

## Dependency Injection
- Use constructor injection: `func NewOrderService(repo core.OrderRepository) *OrderService`
- Do not use global state or `init()`

## Comments
- Only comment non-obvious logic
- Exported types and functions must have a doc comment
- Do not add comments that restate the code
