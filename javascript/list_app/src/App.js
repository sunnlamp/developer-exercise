import React, { Component } from 'react';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      quotes: []
    };
  }

  componentDidMount() {
    fetch("https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json")
      .then(response => response.json())
      .then((data) => {
        this.setState({
          quotes: data
        })
      })
      .then(
        console.log(this.state.quotes)
      )
  }



  render() {
    const { quotes } = this.state;
    return (
      <ul>
        {quotes.map((quote, index) => (
          <li key={index}>
            {quote.source}
          </li>
        ))}
      </ul>
    )
  }
}

export default App;
