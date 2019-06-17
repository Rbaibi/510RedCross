import { fetch } from 'whatwg-fetch';
import _ from 'lodash';

const baseUrl = 'https://ENTER_YOUR_URL.com/510';
export const checkStatus = (response) => {
  if (response.status >= 200 && response.status < 300) {
    return response;
  }

  const error = new Error(response.statusText);
  error.response = response;
  throw error;
};

export const parseJSON = (response) => {
  return response.json();
};

class TaskService {
	get(volunteerId) {
    return request.get(`${baseUrl}/tasks/?volunteer=${volunteerId}`);
  }
}

class Request {
  post(url, data, contentType) {
    const type = _.isUndefined(contentType) ? 'application/json' : contentType;

    const options = {
      method: 'post',
      headers: {
        'Content-Type': type,
      },
      body: JSON.stringify(data),
    };

    return fetch(url, options)
      .then(checkStatus)
      .then(parseJSON);
  }

  get(url, data, contentType) {
    const type = _.isUndefined(contentType) ? 'application/json' : contentType;

    const options = {
      method: 'get',
      headers: {
        'Content-Type': type,
      },
      body: JSON.stringify(data),
    };

    return fetch(url, options)
      .then(checkStatus)
      .then(parseJSON);
  }
}

const request = new Request();

export {
  TaskService,
}
