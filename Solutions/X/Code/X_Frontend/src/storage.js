class LocalStore {
  getItem(key) {
    const data = localStorage.getItem(key);
    return data ? JSON.parse(decodeURIComponent(data)) : {};
  }

  removeItem(key) {
    localStorage.removeItem(key);
  }

  setItem(key, value) {
    const data = encodeURIComponent(JSON.stringify(value));
    localStorage.setItem(key, data);
  }
}

export default new LocalStore();
