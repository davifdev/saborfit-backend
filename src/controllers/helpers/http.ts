export function OK<T>(body: T) {
  return {
    statusCode: 200,
    body,
  };
}

export function CREATED<T>(body: T) {
  return {
    statusCode: 201,
    body,
  };
}

export function BAD_REQUEST<T>(body: T) {
  return {
    statusCode: 400,
    body,
  };
}

export function UNAUTHORIZED<T>(body: T) {
  return {
    statusCode: 401,
    body,
  };
}

export function FORBIDDEN() {
  return {
    statusCode: 403,
    body: {
      message: "Forbidden",
    },
  };
}

export function NOT_FOUND<T>(body: T) {
  return {
    statusCode: 404,
    body,
  };
}

export function INTERNAL_SERVER_ERROR() {
  return {
    statusCode: 500,
    body: {
      message: "Internal Server Error",
    },
  };
}
