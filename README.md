<h1 align="center">Enterprise 🛸 </h1> 
<p align="center">“Logic is the beginning of wisdom, not the end.”</p>

----
<p align="center">
    <img alt="ruby version: 3.2.2" src="https://img.shields.io/badge/Ruby-3.2.2-brightgreen" />
    <img alt="rails version: 7.0.4" src="https://img.shields.io/badge/Rails-7.0.4-brightgreen" />
    <img alt="tailwind version: 3.3.0" src="https://img.shields.io/badge/Tailwind-3.3.0-blue" />
    <img alt="fomantic version: 2.9.2" src="https://img.shields.io/badge/Fomantic-2.9.2-blue" />
    <img alt="rspec tests" src="https://github.com/realstorypro/enterprise/actions/workflows/ruby_on_rails.yml/badge.svg" />
</p>

----

Welcome to Enterprise, the open-source project that boldly takes your newsroom where no newsroom has gone before! Inspired by the spirit of exploration and innovation from Star Trek, Enterprise is a cutting-edge AI-driven platform designed to revolutionize the way we create, curate, and distribute news content.

Our goal is to empower journalists, publishers, and content creators with the most advanced AI tools, streamlining the entire newsroom workflow. With Enterprise, you can:

1. Consume news from across the cosmos: Enterprise's Feedly integration automatically collects and curates news feeds from around the world, ensuring your newsroom always has access to the latest and most relevant content.
2. Let AI write the next great story: With the OpenAI integration, Enterprise is capable of automatically generating well-structured and engaging content, letting you focus on the editorial aspect and enhancing the quality of your stories.
3. Illustrate your stories with the art of tomorrow: Our integration with Midjourney and the NexLeg API enables Enterprise to generate visually stunning and contextually relevant images, bringing your content to life and captivating your audience.
4. Publish your news at warp speed: With the StoryPro integration, publishing your content becomes a seamless and automated process, ensuring your newsroom stays ahead of the competition and your readers are always informed.
 
By harnessing the power of AI and these innovative integrations, Enterprise not only enhances the efficiency of your newsroom but also elevates the quality and impact of your content. Join us on this exciting journey as we redefine the future of journalism together!


## Running It

### Assembling

```ruby
AssembleJob.perform_now
```

### Dispensing
```ruby
DispenseJob.perform_now
```


## Local Setup

#### Mailcatcher
Is the best way to test emails in development. It catches all emails sent by your application and displays them in a web interface. You can also use it to test HTML emails during development.

Install mailcatcher gem on OSX
```bash
gem install mailcatcher --pre
```

Run mailcatcher
```bash
mailcatcher
```

The emails can be viewed at http://localhost:1080