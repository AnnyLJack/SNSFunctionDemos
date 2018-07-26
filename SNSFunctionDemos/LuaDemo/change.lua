
require "StatesTable"
require "CapitalsTable"

waxClass{"ViewController",UIViewController}

function addLabel(self)
local label = UILabel:initWithFrame(CGRect(0, 530, 320, 40))
label:setColor(UIColor:blackColor())
label:setText("Hello Wax!")
label:setTextAlignment(UITextAlignmentCenter)
local font = UIFont:fontWithName_size("Helvetica-Bold",50)
label:setFont(font)
self:view():addSubview(label)
--self:view():setBackgroundColor(UIColor:greenColor())
end

function pushToLuaDemo(self)
local statesController = StatesTable:init()
self:navigationController():pushViewController_animated(statesController, true)
end