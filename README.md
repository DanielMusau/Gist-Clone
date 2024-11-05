# GistClone
`GistClone` is a personal project inspired by GitHub's Gist service, created to explore and understand the fundamentals of Elixir Phoenix LiveView. This web application enables users to store, share, and manage code snippets or text snippets. Users can create, save, and comment on gists, providing an interactive way to share code with others.

## Features
- `User Authentication`: Secure login and registration for personalized access.
- `Create, Edit, and Delete Gists`: Full management of user-created gists.
- `Save and Comment on Gists`: Interact with and save other users' gists, including the ability to leave comments.
- `Syntax Highlighting`: Improves readability for various programming languages.
- `Search and Filter Gists`: Quickly find and organize code snippets.

## Installation
To set up and run GistClone locally:

1. Clone the repository:
```
git clone https://github.com/DanielMusau/Gist-Clone.git
cd Gist-Clone
```

2. Install and compile dependencies:
```
mix deps.get
mix deps.compile
```

3. Configure database credentials in config.exs and set up the database:
```
mix ecto.setup
```

4. Run the application:
```
mix phx.server
```

5. Open the app: Visit `http://localhost:4000` in your browser to start using GistClone.

## Technologies
- Frontend: Phoenix LiveView, CSS, JavaScript
- Backend: Elixir with Ecto
- Database: PostgreSQL

## License
This project is open-source and available under the MIT License.