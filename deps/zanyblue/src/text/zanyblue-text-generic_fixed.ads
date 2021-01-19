--  -*- coding: utf-8 -*-
--
--  ZanyBlue, an Ada library and framework for finite element analysis.
--
--  Copyright (c) 2012, 2016, Michael Rohan <mrohan@zanyblue.com>
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions
--  are met:
--
--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--
--    * Neither the name of ZanyBlue nor the names of its contributors may
--      be used to endorse or promote products derived from this software
--      without specific prior written permission.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
--  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
--  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
--  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
--  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
--  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--

with ZanyBlue.Text.Locales;
with ZanyBlue.Text.Arguments;

generic
   type Fixed_Type is delta <>;
package ZanyBlue.Text.Generic_Fixed is

   use ZanyBlue.Text.Locales;
   use ZanyBlue.Text.Arguments;

   type Fixed_Argument_Type is new Fixed_Category_Type with private;

   function Create
     (Fixed_Value : Fixed_Type)
      return Fixed_Argument_Type;
   --  Create a "boxed" instance of fixed value.

   function "+"
     (Fixed_Value : Fixed_Type)
      return Fixed_Argument_Type renames Create;
   --  Utility renaming of the "Create" function.

   overriding function Format
     (Value     : Fixed_Argument_Type;
      Type_Name : String;
      Template  : String;
      Locale    : Locale_Type)
      return String;
   --  Format an enumeration value for printing.

private

   type Fixed_Argument_Type is new Fixed_Category_Type with record
      Data : Fixed_Type;
   end record;

end ZanyBlue.Text.Generic_Fixed;
