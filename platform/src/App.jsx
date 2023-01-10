import { useState } from 'react'
import Nav from './components/Nav.jsx'

function App() {

  return (
    <div className="App dark">
      <Nav />
      <div className="min-h-full bg-white dark:bg-black">
        <h1 className="text-black dark:text-white">
          Hello
        </h1>
      </div>
    </div>
  )
}

export default App
