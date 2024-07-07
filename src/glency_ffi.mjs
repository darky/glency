const cache = new Map();

export const stub = () => {};

export const di = (key, args, cb) => {
  if (cache.has(key)) {
    return cache.get(key)(...args);
  }
  return cb();
};

export const withDi = (key, mock, cb) => {
  cache.set(key, mock);
  cb();
  cache.clear();
};
