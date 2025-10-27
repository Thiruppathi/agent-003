from google.adk.agents.llm_agent import Agent

root_agent = Agent(
    model='gemini-flas',
    name='root_agent',
    description='An elderly care agent to support older people living alone',
    instruction='Answer user questions to the best of your knowledge',
)
