# Zabbix Conference 2016

Supporting files for my Zabbix Conference 2016 talk in Riga, Latvia

Check out:

* [My speaker interview](http://blog.zabbix.com/introducing-speakers-of-zabbix-conference-2016-part-1/5147/)
* [Conference details](http://www.zabbix.com/conference2016.php)

## Quick references:

* Walk for available OIDs: `$ snmpwalk -c public -v 2c localhost`
* OIDs:
  * iso.org.dod.internet.mgmt.mib-2.system: 1.3.6.1.2.1.1
  * iso.org.dod.internet.mgmt.mib-2.interfaces 1.3.6.1.2.1.2.2

## Windows agent UserParameters

	UserParameter=perf_counter.discovery[*],%systemroot%\system32\windowspowershell\v1.0\powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "Get-CounterSetInstances -CounterSet $1 | ConvertTo-ZabbixDiscovery"
	
	UserParameter=ps.ping,%systemroot%\system32\windowspowershell\v1.0\powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -Command "Write-Host 1"


## License

Copyright (c) 2016 Ryan Armstrong

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.