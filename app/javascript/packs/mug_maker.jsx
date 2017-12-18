import React from 'react';
import {render} from 'react-dom';
import * as PropTypes from 'prop-types';

class MugMaker extends React.Component {
  static contextTypes = {
    easdk: PropTypes.object,
  };

  constructor(props) {
    super(props);
  }

  render() {
    return (
      <p>"Hello again from react"</p>
    );
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const node = document.getElementById('page');
  render(
    <MugMaker />,
    node
  )
});
