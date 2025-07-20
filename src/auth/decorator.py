from functools import wraps

from starlette.requests import Request
from starlette.responses import JSONResponse
from starlette.status import HTTP_401_UNAUTHORIZED


def login_required(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        request: Request = kwargs.get("request") or (args[0] if args else None)

        if not hasattr(request.state, "user") or request.state.user is None:
            return JSONResponse(
                status_code=HTTP_401_UNAUTHORIZED,
                content={"detail": "Authentication invalid"},
            )
        return func(*args, **kwargs)

    return wrapper
