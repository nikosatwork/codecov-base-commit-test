from app.ext import normalize


def test_normalize_nonzero() -> None:
    result = normalize([2, 3, 5])
    assert result == [0.2, 0.3, 0.5]


def test_normalize_zero() -> None:
    assert normalize([0, 0]) == [0.0, 0.0]
