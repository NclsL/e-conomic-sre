from fastapi.testclient import TestClient
from .main import app

client = TestClient(app)


def test_main_throws_exception_with_string_param():
    response = client.get('/this-should-not-work-since-we-want-strings-here')
    assert response.status_code == 422
