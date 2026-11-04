export function OK<T>(body: T) {
  return {
    statusCode: 200,
    body,
  };
}
