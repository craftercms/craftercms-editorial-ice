import { makeStyles } from '@material-ui/core/styles';

export const useStyles = makeStyles((theme) => ({
  '@global': {
    'html, body': {
      background: '#f3f3f3',
      fontFamily: '"Source Sans Pro", "Open Sans", sans-serif'
    }
  },
  root: {},
  spinner: {
    textAlign: 'center',
    margin: '50px auto'
  },
  header: {
    textAlign: 'center',
    paddingBottom: theme.spacing(1),
    margin: `0 0 ${theme.spacing(2)}px`,
    borderBottom: `1px solid ${theme.palette.divider}`
  },
  logoutContainer: {
    margin: '1em 0'
  },
  mainContent: {
    maxWidth: 300,
    margin: 'auto'
  },
  siteView: {
    maxWidth: 500,
    margin: 'auto'
  },
  siteViewHeader: {
    paddingBottom: theme.spacing(1),
    margin: `0 0 ${theme.spacing(1)}px`,
    borderBottom: `1px solid ${theme.palette.divider}`
  },
  siteViewHeaderMain: { display: 'flex', alignItems: 'center' },
  codePaper: {
    padding: theme.spacing(1),
    marginBottom: theme.spacing(1)
  },
  code: {
    maxWidth: '100%',
    overflow: 'auto'
  },
  fieldView: {
    marginBottom: theme.spacing(3)
  },
  textCenter: {
    textAlign: 'center'
  },
  img: {
    maxWidth: '100%'
  }
}));
