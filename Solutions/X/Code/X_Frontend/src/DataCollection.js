import React from 'react';

import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import PlayArrow from '@material-ui/icons/PlayArrow';
import Done from '@material-ui/icons/Done';
import Clear from '@material-ui/icons/Clear';
import { useStyles } from './styles.js';
import logo from './logo.png';
import Button from '@material-ui/core/Button';
import {geolocated} from 'react-geolocated';
import Plot from 'react-plotly.js';

var varX = [];
var varY = [];


export const DataCollection = (props) => {
  const classes = useStyles();
  const showPosition = (position) => console.log(position);
navigator.geolocation.getCurrentPosition(showPosition);
  return (
    <div>
      <img src={logo} className="image" />

      <h3> Task Description </h3>
      <p> Instructions </p>

      <Plot
        data={[
          {
            x: varX,
            y: varY,
            type: 'scatter',
            mode: 'lines+markers',
            marker: {color: 'red'},
          }  
        ]}
        layout={{width: 320, height: 240, xlabel: 'Longitude'}}
      />

      <Grid container>
        <Grid item><p>Start collecting</p></Grid>
	<Grid item><PlayArrow className={classes.iconHover} fontSize="large" color="secondary"/></Grid>
      </Grid>

	<Grid container>
        <Grid item><p> Is there flood? </p></Grid>
	<Grid item><Done className={classes.iconHover} fontSize="large" color="secondary"/></Grid>
	<Grid item><Clear className={classes.iconHover} fontSize="large" color="secondary"/></Grid>
      </Grid>
      
	<Grid container>
	<Grid item>
	<Button variant="contained" color="secondary">
        	Upload
        </Button>
	</Grid>
	</Grid>

    </div>
  );
}