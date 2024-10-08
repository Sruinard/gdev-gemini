
import pytest
from httpx import AsyncClient, ASGITransport

from gems.main import app


@pytest.fixture
async def client():
    """Fixture to create a FastAPI test client."""
    return AsyncClient(transport=ASGITransport(app=app), base_url="http://test")

@pytest.mark.anyio
async def test_read_main(client):
    response = await client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello World"}
