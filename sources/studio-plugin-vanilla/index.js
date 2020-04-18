/*
 * Copyright (C) 2007-2020 Crafter Software Corporation. All Rights Reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as published by
 * the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// /studio/plugin?site=editorial&type=apps&name=vanilla

(function ({
  // It's good if you use these React & ReactDOM instead
  // of your own bundle just to reduce payload of the page.
  // These will be available for sure.
  React,
  ReactDOM,
  // You could use Crafter CMS components this way for now.
  // They'll get published to npm eventually.
  components: {
    CrafterCMSNextBridge,
    AuthMonitor,
    ErrorState
  },
  // You could use Crafter CMS services this way for now.
  // They'll get published to npm eventually.
  services: {
    auth,
    sites: sitesServices
  },
  system: { store }
}) {

  let createElement = React.createElement;
  let elem = document.createElement('div');
  let state = store.getState();
  let sites;

  document.body.appendChild(elem);

  render();

  sitesServices.fetchSites().subscribe((response) => {
    sites = response;
    render();
  });

  store.subscribe(() => {
    state = store.getState();
    render();
  });

  function render() {
    ReactDOM.render(
      createElement(
        'div',
        {
          style: {
            fontFamily: 'sans-serif',
            textAlign: 'center',
            maxWidth: '500px',
            margin: '50px auto'
          }
        },
        createElement(
          CrafterCMSNextBridge,
          null,
          createElement(
            ErrorState,
            {
              graphicUrl: '/studio/static-assets/images/content_creation.svg',
              error: {
                title: 'Vanilla Plugin',
                message: `Hello, ${state.user ? (state.user.firstName || state.user.username) : 'anonymous'}`
              }
            }
          ),
          createElement(AuthMonitor)
        ),
        createElement(
          'div', { style: { marginBottom: '80px' } },
          sites ? (
            createElement(
              React.Fragment, null,
              createElement('h2', null, 'Your Sites'),
              createElement('p', null, sites.map(site => site.name).join(', '))
            )
          ) : createElement('p', null, 'Fetching sites...')
        ),
        createElement(
          'button',
          {
            style: {
              'border-radius': '25px',
              padding: '10px 20px',
              background: 'rgb(0, 122, 255)',
              color: 'rgb(255, 255, 255)',
              'font-size': '16px',
              'box-shadow': '0 0 4px rgba(0, 0, 0, .25)',
              outline: 'none'
            },
            onClick() {
              auth.logout().subscribe(
                () => {
                  store.dispatch({ type: 'VALIDATE_SESSION' });
                },
                () => {
                  store.dispatch({
                    type: 'SHOW_CONFIRM_DIALOG',
                    payload: {
                      title: 'Error',
                      body: 'Error occurred logging out.'
                    }
                  });
                }
              );
            }
          },
          'Log Out'
        )
      ),
      elem
    );
  }

}) (CrafterCMSNext);
