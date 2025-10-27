from google.adk.agents.llm_agent import Agent

root_agent = Agent(
    model='gemini-live-2.5-flash-preview-native-audio-09-2025',
    name='root_agent',
    description='An elderly care agent to support older people living alone',
    instruction='Answer user questions to the best of your knowledge',
)
