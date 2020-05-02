import React, { useState } from 'react';
import IconButton from '@material-ui/core/IconButton';
import { ArrowBackRounded } from '@material-ui/icons';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Input from '@material-ui/core/Input';
import Button from '@material-ui/core/Button';
import { updateField } from '@rart/25d0661d/services/content';
import Snackbar from '@material-ui/core/Snackbar';

export default function ComponentView({ onBack, classes, resource, siteId }) {
  const { content, contentType } = resource.read();
  return (
    <section className={classes.siteView}>
      <header className={classes.siteViewHeader}>
        <div className={classes.siteViewHeaderMain}>
          <IconButton color="primary" onClick={onBack}>
            <ArrowBackRounded />
          </IconButton>
          <Typography variant="h5" component="h2" children={content.craftercms.label} />
        </div>
        <Typography
          color="textSecondary"
          children={`${contentType.name} - ${content.craftercms.path}`}
        />
      </header>
      <Paper className={classes.codePaper}>
        {
          Object.entries(content).map(([fieldName, value]) => {
            if (fieldName === 'craftercms') {
              return null;
            }
            return (
              <FieldView
                siteId={siteId}
                value={value}
                key={fieldName}
                classes={classes}
                path={content.craftercms.path}
                field={contentType.fields[fieldName]}
              />
            );
          })
        }
      </Paper>
      <Paper className={classes.codePaper}>
        <pre className={classes.code}>
          {JSON.stringify(content, null, '  ')}
        </pre>
      </Paper>
      <Paper className={classes.codePaper}>
        <pre className={classes.code}>
          {JSON.stringify(contentType, null, '  ')}
        </pre>
      </Paper>
    </section>
  );
}


function FieldView({ field, value, classes, path, siteId }) {
  let render = value;
  switch (field?.type) {
    case 'image':
      render = <img className={classes.img} src={`//localhost:8080${value}`} alt="" />;
      break;
    case 'node-selector':
      render = '(Nested component(s))';
      break;
    case 'text': {
      if (path) {
        render = <TextUpdater siteId={siteId} path={path} field={field} value={value} />;
      }
      break;
    }
    case 'html': {
      render = <div dangerouslySetInnerHTML={{ __html: value }} />;
      break;
    }
    case undefined:
      return (
        <section className={classes.fieldView}>
          <Typography
            color="error"
            children="Error: No field received. Model might be out of sync with the conten type."
          />
        </section>
      );
    default:
      break;
  }
  if (typeof value === 'object') {
    render = '(nested component/value not rendered)';
  }
  return (
    <section className={classes.fieldView}>
      <header className={classes.siteViewHeader}>
        <div className={classes.siteViewHeaderMain}>
          <Typography variant="h6" component="h3" children={field.name} />
        </div>
        <Typography color="textSecondary" children={field.type} />
      </header>
      {render}
    </section>
  );
}

function TextUpdater({ path, value, field, classes, siteId }) {
  const [val, setVal] = useState(value);
  const [snack, setSnack] = useState({ open: false });
  const onUpdateClick = () => {
    if (val) {
      updateField(siteId, path, field.id, null, null, val).subscribe(
        () => setSnack({ open: true, message: 'Update successful' }),
        () => setSnack({ open: true, message: 'Update failed' })
      );
    }
  };
  const onCloseSnack = () => {
    setSnack({ open: false });
  };
  return (
    <div>
      <Input value={val} onChange={(e) => setVal(e.target.value)} />
      <Button variant="contained" color="primary" onClick={onUpdateClick}>
        Update
      </Button>
      <Snackbar
        open={snack.open}
        anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}
        autoHideDuration={5000}
        onClose={onCloseSnack}
        message={snack.message}
      />
    </div>
  );
}
