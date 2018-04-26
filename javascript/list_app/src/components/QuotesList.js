import React from 'react';
import ListItem from './ListItem';

const QuotesList = (props) => {
  const quotesItems = props.quotes.map((quote, index) => {
    return (
      <ListItem
        key={index}
        source={quote.source}
        quote={quote.quote}
        context={quote.context}
      />
    )
  })

  return (
    <ul>
      {quotesItems}
    </ul>
  )
}

export default QuotesList;
