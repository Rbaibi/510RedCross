import React, { useState, useEffect } from 'react';

import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import PlayArrow from '@material-ui/icons/PlayArrow';
import { useStyles } from './styles.js';
import {TaskService} from './service.js';
import Button from '@material-ui/core/Button';
import logo from './logo.png';

const taskService = new TaskService();

const divStyleTaskActive = {
  color: 'red', //#DF0101,
  fontSize: 'x-large',
};

const divStyleTaskComplete = {
  color: 'blue', //#E6E6E6,
  fontSize: 'small',
};

export const Task = (props) => {
  const { task } = props;
  const classes = useStyles();
  switch(task.status) {
    case 'active':
      return <Button onClick={()=>props.onSelect(task)} variant="contained" color="secondary" className={classes.button}>
                {task.task}
              </Button>
    case 'complete':
      return <Button variant="contained" color="secondary" disabled className={classes.button}>
          {task.task}
        </Button>
      // return <div className={classes.textField} style={divStyleTaskComplete} key={task.id}>{task.task}</div>
    default:
  }
}

export const Tasks = (props) => {
  const [tasks, setTasks] = useState(0);
  useEffect(() => {
    const fetchData = async () => {
      const result = await taskService.get(props.volunteerId);
      setTasks(result)
    };
    fetchData();
  }, []);

  if (tasks.length) {
    return (
      <div>
        <Grid container className="tasklist">
          {tasks.map((task)=> <Task task={task} key={task.id}
            onSelect={props.taskSelected}/>)}
        </Grid>
      </div>
    );
  }
  return <div>Loading</div>;
}

