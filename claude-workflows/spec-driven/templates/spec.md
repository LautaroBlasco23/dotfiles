# Spec: <Feature Name>

## Feature
<One-sentence description of what this feature does.>

## Business Rules
- <rule 1>
- <rule 2>

## API

### Request
POST /path

```json
{
  "field": "type"
}
```

### Response
```json
{
  "field": "type"
}
```

### Error Cases
- `400`: <condition>
- `404`: <condition>
- `409`: <condition>

## Domain Model

### <EntityName>
- `id`: uuid
- `field`: type

## Assumptions
- <assumption made when requirements were ambiguous>
