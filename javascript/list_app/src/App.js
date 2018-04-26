import _ from 'underscore';
import React, { Component } from 'react';
import './App.css';
import QuotesList from './components/QuotesList';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLoaded: false,
      quotes: [],
      currentPage: 1,
      quotesPerPage: 15
    };

    this.handlePageClick = this.handlePageClick.bind(this);
  }

  handlePageClick(event) {
    this.setState({
      currentPage: Number(event.target.id)
    })
  }

  componentDidMount() {
    fetch("https://gist.githubusercontent.com/anonymous/8f61a8733ed7fa41c4ea/raw/1e90fd2741bb6310582e3822f59927eb535f6c73/quotes.json")
      .then(response => response.json())
      .then((data) => {
        this.setState({
          isLoaded: true,
          quotes: _.shuffle(data)
        })
      })
  }

  render() {
    const { isLoaded, quotes, currentPage, quotesPerPage } = this.state;

      const indexOfLastQuote = currentPage * quotesPerPage;
      const indexOfFirstQuote = indexOfLastQuote - quotesPerPage;
      const currentQuotes = _.toArray(this.state.quotes).slice(indexOfFirstQuote, indexOfLastQuote);

      // Logic for displaying page numbers
      const pageNumbers = [];
      for (let i = 1; i <= Math.ceil(quotes.length / quotesPerPage); i++) {
        pageNumbers.push(i);
      }

      const renderPageNumbers = pageNumbers.map(number => {
        return (
          <button
            key={number}
            id={number}
            onClick={this.handlePageClick}
          >
            {number}
          </button>
        );
      });

      if (!isLoaded) {
        return <div>Loading..</div>
      } else {
        return (
          <div>
            <QuotesList
              quotes={currentQuotes}
            />
            <ul>
              {renderPageNumbers}
            </ul>
          </div>
        )
      }
  }
}

export default App;
