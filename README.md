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
5. Distribute your news across the social cosmos: With our integration with Ayrshare, Enterprise enables you to automatically share your news content across multiple social media platforms. This ensures your stories reach a wider audience and increases your newsroom's digital footprint.

By harnessing the power of AI and these innovative integrations, Enterprise not only enhances the efficiency of your newsroom but also elevates the quality and impact of your content. Join us on this exciting journey as we redefine the future of journalism together!

# Step-by-Step Setup Instructions
### Step 1: Fork the repository
Start by cloning the repository to your local machine. You can do this by using the `git clone` command followed by the URL of the repository. 
Once cloned, navigate into the repository by using the `cd` command, and install the necessary dependencies by running the `bundle install` command.

### Step 2: Create a customization branch
Establish a customization branch  through the command `git checkout -b customizations`. This particular branch will serve as the base for your modifications to the Enterprise.
Future synchronizations of any alterations made to this repository can be achieved using [fork syncing](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/syncing-a-fork), 
and subsequently, these changes can be integrated into your personalization branch.

### Step 2: Create a new .env file
In the repository, you will find a file named `.env.example`. Make a copy of this file and rename it to `.env`. You can do this by running the following command: `cp .env.example .env`.

### Step 3: Populate the .env file
Open the newly created `.env` file and fill it with the necessary keys and values. You may need to sign up for certain services to obtain these keys. The `.env.example` file includes comments with instructions on how to obtain each key.

### Step 4: Generate blueprints
Run the `rails generate blueprints` command. This will copy the blueprint files into the `blueprints` directory.

### Step 5: Modify the blueprint files
Change the `topics.yml` and `prompts.yml` files in the blueprints directory to reflect the feeds and prompts you want to use.

### Step 6: Fine-Tune story generation
In the future, you can fine-tune story generation by excluding unwanted tags in the `tunings.yml` file.

### Step 7: Update the blueprints
Once you've made your changes, execute the `rake blueprints:update` command. This will load your changes into the database.

### Step 8: Set Up the Database
After updating the blueprints, it's time to set up your database. Run the following commands to create the database and load the schema:
```bash
rails db:create
rails db:schema:load
```

### Step 9: Install Foreman
If you don't have Foreman installed, you can install it using the following command: `gem install foreman`.

### Step 10: Ensure Redis is Installed and Running
Ensure that Redis is installed and running on your machine. If using Homebrew you can install it with the following command: `brew install redis`. To start Redis, use the command: `brew services start redis`.

### Step 11: Start the Application
Finally, you can start the application by running the following command: `foreman start -f Procfile.dev`.

### Step 12: Create an Account
Head over to `https://localhost:3000` and create a user account. 

### Step 13: Give account access privileges
Head over to the console and pull up the account you've just created, then give it access privileges by running the following commands:
```ruby
# pulls up the newly user
user = User.last

# gives access to the application
user.give_access

# gives access to sidekiq web ui. This is optional, but useful for debugging
user.make_admin
````

### Step 14: Setup Proxy
NextLeg uses webhooks to communicate with Enterprise about the status of the images it generates. To enable this communication, you need to setup a proxy on your local machine. In this example we are using a paid service called ngrok, but you can use any proxy service you like.

```bash
 ngrok http 3000 --subdomain=custom_subdomain
```

### Step 15: Setup NexLeg
Log into your NextLeg account, navigate to your account settings, and update the webhook URL to point to the proxy URL you've just created.
`https://custom_subdomain.ngrok.io/webhooks/midjourney`


# Running It
Enterprise uses a series of jobs to automate the process of generating and publishing stories. These jobs can be scheduled to run automatically using a cron job or manually executed for setup and troubleshooting.

### Assembling Job
The Assembling Job is responsible for:
- Fetching new feed items from Feedly.
- Converting these feeds into stories and tweets with the help of OpenAI.
- Uploading new images to UploadCare.
 
To manually execute the Assembling Job, open your console and run the following command:

```ruby
AssembleJob.perform_now
```

This command will immediately start the Assembling Job, allowing you to monitor its progress and troubleshoot any issues.

### Image Processing Job
The Image Processing Job is responsible for queuing up image ideas to Midjourney via NextLeg. __Before running this job, ensure that your proxy is set up correctly.__

To manually execute the Image Processing Job, open your console and run the following command:
```ruby
Images::ImagineImagesJob.perform_now
```

This command will immediately start the Image Processing Job, allowing you to monitor its progress and troubleshoot any issues.

### Publishing Job

The Publishing Job is responsible for:
_ Publishing discussions to StoryPro.
_ Scheduling tweets via Ayrshare.

To manually execute the Publishing Job, open your console and run the following command:
```ruby
Images::PublishJob.perform_now
```

This command will immediately start the Publishing Job, allowing you to monitor its progress and troubleshoot any issues.

## Scheduling Jobs
If you want to automate these jobs, you can schedule them to run at specific intervals using a cron job. To do this, you'll need to use the `rake simple_scheduler` command.
This command will start the Simple Scheduler, which will automatically execute the jobs according to the schedule defined in `config/simple_scheduler.yml` file.


## Mailcatcher
Mailcatcher is a useful tool for testing emails in development. It catches all emails sent by your application and displays them in a web interface. You can also use it to test HTML emails during development.

Install mailcatcher gem on OSX
```bash
gem install mailcatcher --pre
```

Run mailcatcher
```bash
mailcatcher
```

You can then view the emails sent by your application by navigating to [http://localhost:1080](http://localhost:1080) in your web browser.

# Deploying to Heroku
Step 1. Create a new Heroku app
```bash
heroku create
```

Step 2. Deploy the customizations branch
```bash
git push heroku customizations:main
```

Step 3. Configure the environment variables