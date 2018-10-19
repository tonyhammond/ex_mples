defmodule TestSuper do
  @moduledoc """
  Top-level module used in
  "[Robust compute for RDF queries](https://medium.com/@tonyhammond/robust-compute-for-rdf-queries-eb2ad665ef12)"
  post.

  The post aims to demo how to manage fault tolerance in Elixir with
  supervision trees. It first reviews the process model for Erlang (Elixir)
  and then discusses the abstraction patterns that OTP provides for processes:
  agents, servers, supervisors, and tasks.

  The post demos the `GenServer`, `Supervisor`, and `DynamicSupervisor` patterns.
  """

  ## 1. `GenServer`s

  @doc """
  Constructor for new `GenServer` (with no supervision).

  Returns process ID for `GenServer`.

  ## Examples

      iex> genserver
      TestSuper.Server is starting ... #PID<0.224.0>
      #PID<0.224.0>
  """
  def genserver() do
    opts = [
    ]
    case TestSuper.Server.start_link(opts) do
      {:ok, pid} ->
        IO.puts "TestSuper.Server is starting ... #{inspect pid}"
        pid
      {:error, reason} ->
        IO.puts "! Error: #{inspect reason}"
    end
  end

  @doc """
  Constructor for new `GenServer` (with `Supervisor`).

  Returns process ID for `GenServer`.

  ## Examples

      iex> genserver_s
      TestSuper.Server is starting ... #PID<0.229.0>
      TestSuper.Supervisor is starting ... #PID<0.228.0>
      #PID<0.229.0>
  """
  def genserver_s() do
    opts = [
      name: TestSuper.Supervisor,
      strategy: :one_for_one
    ]
    case TestSuper.Supervisor.start_link(opts) do
      {:ok, pid} ->
        [{_, child_pid, _, _}] = Supervisor.which_children(pid)
        IO.puts "TestSuper.Supervisor is starting ... #{inspect pid}"
        IO.puts "TestSuper.Server is starting ... #{inspect child_pid}"
        child_pid
      {:error, reason} ->
        IO.puts "! Error: #{inspect reason}"
    end
  end

  @doc """
  Constructor for new `GenServer` (with `DynamicSupervisor`).

  Returns process ID for `GenServer`.

  ## Examples

      iex> genserver_d
      TestSuper.Server is starting ... #PID<0.233.0>
      #PID<0.233.0>
  """
  def genserver_d() do
    case DynamicSupervisor.start_child(
        TestSuper.DynamicSupervisor, TestSuper.Server
      ) do
      {:ok, pid} ->
        # IO.puts "TestSuper.Server is starting ... #{inspect pid}"
        pid
      {:error, reason} ->
        IO.puts "! Error: #{inspect reason}"
    end
  end

  ## 2. `Supervisor`s

  @doc """
  Constructor for new `Supervisor` (with `GenServer`).

  Returns process ID for `Supervisor`.

  ## Examples

      iex> supervisor
      TestSuper.Server is starting ... #PID<0.229.0>
      TestSuper.Supervisor is starting ... #PID<0.228.0>
      #PID<0.228.0>
  """
  def supervisor() do
    opts = [
      name: TestSuper.Supervisor,
      strategy: :one_for_one
    ]
    case TestSuper.Supervisor.start_link(opts) do
      {:ok, pid} ->
        [{_, child_pid, _, _}] = Supervisor.which_children(pid)
        IO.puts "TestSuper.Supervisor is starting ... #{inspect pid}"
        IO.puts "TestSuper.Server is starting ... #{inspect child_pid}"
        pid
      {:error, reason} ->
        IO.puts "! Error: #{inspect reason}"
    end
  end

  @doc """
  Constructor for new `DynamicSupervisor`.

  Returns process ID for `DynamicSupervisor`.

  ## Examples

      iex> supervisor_d
      TestSuper.DynamicSupervisor is starting ... #PID<0.231.0>
      #PID<0.231.0>
  """
  def supervisor_d() do
    opts = [
      name: TestSuper.DynamicSupervisor,
      strategy: :one_for_one
    ]
    case TestSuper.DynamicSupervisor.start_link(opts) do
      {:ok, pid} ->
        IO.puts "TestSuper.DynamicSupervisor is starting ... #{inspect pid}"
        pid
      {:error, reason} ->
        IO.puts "! Error: #{inspect reason}"
    end
  end

end
