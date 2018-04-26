import React, { Component } from 'react';
import './App.css';
import _ from 'underscore';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoaded: false,
      quotes: []
    };
  }

  componentDidMount() {
    fetch("https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json")
      .then(response => response.json())
      .then((data) => {
        this.setState({
          isLoaded: true,
          quotes: _.sortBy(data, 'theme')
        })
      })
  }

  render() {
    const { isLoaded, quotes } = this.state;
      if (!isLoaded) {
        return <div>Loading..</div>
      } else {
        return (
          <ul>
            {quotes.map((quote, index) => (
              <li key={index}>
                {quote.source}, {quote.context}, {quote.quote}
              </li>
            ))}
          </ul>
        )
      }
  }
}

export default App;
