require "rails_helper"

RSpec.describe 'MyCustomLogger' do
  context 'my logger' do
    it 'supports info' do
      expect { MyCustomLogger.info("Hello world") }.to output("[INFO] Hello world\n").to_stdout_from_any_process
    end

    it 'supports warn' do
      expect { MyCustomLogger.warn("This is a warning") }.to output("[WARN] This is a warning\n").to_stdout_from_any_process
    end

    it 'supports error' do
      expect { MyCustomLogger.error("This is a error") }.to output("[ERROR] This is a error\n").to_stdout_from_any_process
    end
  end

  context 'my reverse logger' do
    it 'writes messages in reverse' do
      expect { MyReverseLogger.info("Hello world") }.to output("[INFO] dlrow olleH\n").to_stdout_from_any_process
      expect { MyReverseLogger.warn("This is a warning") }.to output("[WARN] gninraw a si sihT\n").to_stdout_from_any_process
      expect { MyReverseLogger.error("This is a error") }.to output("[ERROR] rorre a si sihT\n").to_stdout_from_any_process
    end
  end

  context 'buffer logger' do
    it 'writes stacked messages' do
      MyCustomLogger.error_size= 3
      MyCustomLogger.warn_size= 2
      expect { MyCustomLogger.info("Hello") }.to output("[INFO] Hello\n").to_stdout_from_any_process
      expect { MyCustomLogger.warn("blabla") }.to_not output.to_stdout_from_any_process
      expect { MyCustomLogger.warn("umbrella") }.to output("[WARN] blabla\n[WARN] umbrella\n").to_stdout_from_any_process
      expect { MyCustomLogger.warn("hello") }.to_not output.to_stdout_from_any_process
      expect { MyCustomLogger.error("oops") }.to_not output.to_stdout_from_any_process
      expect { MyCustomLogger.error("ooopsie") }.to_not output.to_stdout_from_any_process
      expect { MyCustomLogger.warn("what") }.to output("[WARN] hello\n[WARN] what\n").to_stdout_from_any_process
      expect { MyCustomLogger.error("ouch") }.to output("[ERROR] oops\n[ERROR] ooopsie\n[ERROR] ouch\n").to_stdout_from_any_process
    end
  end
  context 'tagged logger' do
    it 'writes tagged messages' do
      expect { MyCustomLogger.logger.tagged('API Calls','INFO').info('message') }.to output("[API Calls] [INFO] message\n").to_stdout_from_any_process
    end
  end
end