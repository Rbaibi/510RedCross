import React from 'react';
import './App.css';

import { TaskService } from './service.js';
import Storage from './storage.js';

import { Home } from './Home';
import { Tasks } from './Tasks';
import { DataCollection } from './DataCollection';

const taskService = new TaskService();

class App extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      step: 1,
      task: undefined
    }
  }

  render() {
    const date = new Date();
    Storage.setItem('date', date);

    const { step, task } = this.state;

    switch (step) {
      case 1:
        return (
          <div className="App">
            <Home onNext={() => this.setState({ step: 2 })} />
          </div>
        );
      case 2:
        return <Tasks volunteerId="rodrigo-goncalves" taskSelected={(task) => this.setState({ task, step: 3 })}/>
      case 3:
        return (
          <div>
            <DataCollection task={task}/> 
          </div>
        );
    }
  }
}

export default App;
