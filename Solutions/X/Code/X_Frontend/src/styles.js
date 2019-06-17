import { makeStyles, withStyles } from '@material-ui/core/styles';
import { blue, red } from '@material-ui/core/colors';

export const useStyles = makeStyles(theme => ({
  container: {
    display: 'flex',
    flexWrap: 'wrap',
  },
  textField: {
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
  },
  menu: {
    width: 200,
  },
  iconHover: {
    '&:hover': {
      color: red[800],
    },
  },
  button: {
    margin: "theme.spacing(100)",
    width: "100%"
  },
  buttonGridItem: {
    width: "100%",
  }
}));
