def normalize(values: list[int]) -> list[float]:
    total = sum(values)
    if total == 0:
        return [0.0 for _ in values]
    return [value / total for value in values]
