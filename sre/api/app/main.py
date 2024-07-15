import logging
from fastapi import FastAPI, Response, HTTPException, status
from enum import Enum
import magic
import requests

app = FastAPI()


class EndpointLogFilter(logging.Filter):
    def filter(self, record: logging.LogRecord) -> bool:
        return record.getMessage().find("/health") == -1


logging.getLogger("uvicorn.access").addFilter(EndpointLogFilter())


class AllowedMimeTypes(str, Enum):
    pdf = 'application/pdf'
    png = 'image/png'


@app.get("/health")
async def healthcheck() -> str:
    return "200"


# {number:path} will capture the random ID into the variable 'number'
@app.get(
    "/{number:path}",
    response_description="Returns .pdf or .png depending on the `number`",
    responses={
        200: {"description": "An image or pdf from an external service", "content": {"image/png": {}, "application/pdf": {}}},
        500: {"description": "Couldn't fetch data from an external service"},
        501: {"description": "Unable to determine filetype"}},
    response_class=Response
)
async def file(number: int) -> Response:
    request = requests.get("http://localhost:3000")

    if request.status_code != status.HTTP_200_OK:
        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Unable to fetch file from external service")

    filetype = magic.from_buffer(request.content, mime=True)

    if filetype != AllowedMimeTypes.png and filetype != AllowedMimeTypes.pdf:
        raise HTTPException(status_code=status.HTTP_501_NOT_IMPLEMENTED, detail="Unable to determine filetype of the file fetched from an external service")

    headers = {}
    if filetype == AllowedMimeTypes.pdf:
        headers = {'Content-Disposition': 'inline; filename="not-so-dummy.pdf"'}

    return Response(content=request.content, headers=headers, media_type=filetype)
