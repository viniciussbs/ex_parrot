defmodule ExParrotWeb.Router do
  use ExParrotWeb, :router

  scope "/", ExParrotWeb do
    match :*, "/*anything", MimicController, :mimic
  end
end
