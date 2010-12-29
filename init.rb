require 'aws_imageshack'
ActionController::Base.helper AwsImageshack::ViewHelpersMethods
ActionController::Base.send :include, AwsImageshack::PublicControllerMethods