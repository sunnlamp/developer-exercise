import React, { Component } from 'react';

class QuoteSearch extends Component {
  constructor(props) {
    super(props);

    this.state = { searchTerm: '' };
  }

  render() {
    return (
      <div>
        <input
          value={this.state.term}
          onChange={event => this.onInputChange(event.target.value)}/>
      </div>
    );
  }

  onInputChange(searchTerm) {
    this.setState({searchTerm})
    this.props.onSearchTermChange(searchTerm)
  }

}

export default QuoteSearch;
