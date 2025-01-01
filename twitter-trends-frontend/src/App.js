import React, { useState } from 'react';
import './App.css'; 

function App() {
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const fetchTrends = async () => {
    setLoading(true);
    setError('');
    try {
      const response = await fetch('http://localhost:8080/fetch-trends', { method: 'POST' });
      if (!response.ok) throw new Error('Failed to fetch trends.');
      const data = await response.json();
      setResult(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const formatDateTime = (isoDate) => {
    const date = new Date(isoDate);
    return new Intl.DateTimeFormat('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      second: 'numeric',
    }).format(date);
  };

  return (
    <div className="container">
      <h1>Trending Topics</h1>
      <div id="results">
        {loading && <p></p>}
        {error && <p style={{ color: 'red' }}>{error}</p>}
        {result && (
          <div>
            <p>These are the most happening topics as on {formatDateTime(result.datetime)}:</p>
            <ul>
              {result.trends.slice(0, 5).map((trend, index) => (
                <li key={index}>{trend}</li>
              ))}
            </ul>
            <p>The IP address used for this query was {result.ipAddress}.</p>
            <p>Here’s a JSON extract of this record from the MongoDB:</p>
            <pre>{JSON.stringify(result, null, 2)}</pre>
          </div>
        )}
      </div>
      <button id="run-script" onClick={fetchTrends}>
        {loading ? 'Fetching...' : 'Click here to run the query'}
      </button>
    </div>
  );
}

export default App;
