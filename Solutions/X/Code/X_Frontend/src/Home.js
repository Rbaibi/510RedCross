import React from 'react';

import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import PlayArrow from '@material-ui/icons/PlayArrow';
import { useStyles } from './styles.js';
import logo from './logo.png';

export const Home = (props) => {
  const classes = useStyles();
  return (
    <div>
      <img src={logo} className="image" />
      <Grid container className="login">
        <Grid item>
          <TextField
           id="volunteerID"
           label="Volunteer ID"
           className={classes.textField}
           variant="outlined"
          />
        </Grid>
	      <Grid item><PlayArrow className={classes.iconHover} fontSize="large" color="secondary" onClick={() => props.onNext()}/></Grid>
      </Grid>
    </div>
  );
}
