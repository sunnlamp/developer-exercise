import _ from 'underscore';
import React from 'react';
import QuotesList from './QuotesList';

const Pagination = ({currentPage, quotesPerPage, lastQuoteIndex,
  firstQuoteIndex, quotes, onPageSelect}) => {
  const currentQuotes = _.toArray(quotes).slice(firstQuoteIndex, lastQuoteIndex);

  return (
    <div>
      <QuotesList
        quotes={currentQuotes}
      />

    </div>
  )
}

export default Pagination;
