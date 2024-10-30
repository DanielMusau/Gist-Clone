defmodule GistCloneWeb.Utilities.DateFormat do
  def get_relative_time(datetime) do
    {:ok, rel_time} = Timex.format(datetime, "{relative}", :relative)
    rel_time
  end
end
